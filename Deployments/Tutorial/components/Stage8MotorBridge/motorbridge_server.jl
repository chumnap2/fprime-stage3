using Sockets
using PyCall

# --- PyVESC setup ---
@pyimport serial
@pyimport pyvesc

println("[Julia] Connecting to VESC on /dev/ttyACM0 ...")
ser = serial.Serial("/dev/ttyACM0", 115200)

function set_duty(duty::Float64)
    duty = clamp(duty, 0.0, 1.0)
    duty_int = Int(round(duty * 100000))
    try
        cmd = pyvesc.SetDutyCycle(duty_int)
        packet = pyvesc.encode(cmd)
        ser.write(Vector{UInt8}(packet))
        println("[Julia] >>> VESC DUTY SENT: $duty")
    catch e
        println("[Julia] ERROR sending duty: ", e)
    end
end

# --- Shared state ---
const motor_enabled = Ref(false)
const target_duty = Ref(0.0)
const current_rpm = Ref(0.0)
const current_amps = Ref(0.0)
const current_voltage = Ref(24.0)
const current_temp = Ref(25.0)

# --- Ramp loop task ---
function ramp_loop()
    step = 0.02
    delay = 0.05
    current = 0.0

    println("[Julia] Starting ramp loop...")

    try
        while true
            if motor_enabled[]
                if current < target_duty[]
                    current = min(current + step, target_duty[])
                elseif current > target_duty[]
                    current = max(current - step, target_duty[])
                end
            else
                current = max(current - step, 0.0)
            end

            # Send duty to VESC
            set_duty(current)

            # Update fake telemetry for testing (replace with actual pyvesc reads)
            current_rpm[] = round(current * 6000)      # example RPM
            current_amps[] = round(current * 30.0)    # example current
            current_voltage[] = 24.0 + current * 4.0
            current_temp[] = 25.0 + current * 5.0

            sleep(delay)
        end
    catch e
        println("[EMERGENCY] Ramp loop stopped: ", e)
        try
            set_duty(0.0)
        catch
        end
        rethrow(e)
    end
end

@async ramp_loop()

# --- TCP server ---
port = 5050
server = listen(ip"127.0.0.1", port)
println("[Julia] MotorBridge server listening on 127.0.0.1:$port")

function read_cmd_line(sock::TCPSocket)
    bytes = readuntil(sock, UInt8('\n'))
    s = try
        String(bytes)
    catch
        hex = join(string.(bytes, base=16), " ")
        println("[Julia] Warning: non-UTF8 bytes: ", hex)
        ""
    end
    return strip(chomp(s))
end

while true
    sock = accept(server)
    println("[Julia] Client connected: $(getpeername(sock))")
    @async begin
        try
            while !eof(sock)
                line = ""
                try
                    line = read_cmd_line(sock)
                catch e
                    if isa(e, EOFError)
                        println("[Julia] Client closed connection")
                        break
                    else
                        rethrow(e)
                    end
                end

                if isempty(line)
                    continue
                end

                cmd = uppercase(line)
                if startswith(cmd, "SET_DUTY:")
                    val = parse(Float64, split(line, ":")[2])
                    target_duty[] = clamp(val, 0.0, 1.0)
                    println("[Julia] SET_DUTY -> ", target_duty[])

                elseif cmd == "ENABLE"
                    motor_enabled[] = true
                    println("[Julia] ENABLE received")

                elseif cmd == "DISABLE"
                    motor_enabled[] = false
                    println("[Julia] DISABLE received")

                # --- NEW: reply to telemetry queries ---
                elseif cmd == "CURRENT_RPM?"
                    send(sock, string(round(current_rpm[])) * "\n")
                elseif cmd == "CURRENT_CURRENT?"
                    send(sock, string(round(current_amps[])) * "\n")
                elseif cmd == "CURRENT_VOLTAGE?"
                    send(sock, string(current_voltage[]) * "\n")
                elseif cmd == "CURRENT_TEMP?"
                    send(sock, string(current_temp[]) * "\n")

                else
                    println("[Julia] unknown command: ", line)
                end
            end
        catch e
            println("[Julia] connection error: ", e)
        finally
            try
                close(sock)
            catch
            end
            println("[Julia] client disconnected")
        end
    end
end
