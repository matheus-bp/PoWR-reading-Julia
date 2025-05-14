function readdat_better(file::String, header::String, wvl1, wvl2)
    # Open and read the file
    lines = readlines(file)
    
    # Find the data section
    starti = 0
    stopi = 0
    for (ii, line) in enumerate(lines)
        if occursin(header, line) && !occursin("Absolut", line)
            starti = ii + 7
            for jj in starti:length(lines)
                if occursin("ENDE", lines[jj])
                    stopi = jj - 1
                    break
                end
            end
            break
        end
    end

    # Parse main data block
    data = []
    for line in lines[starti:stopi-1]
        numbers = [parse(Float64, x) for x in split(line)]
        append!(data, numbers)
    end
    data = reshape(data, (length(data)÷2, 2))
    
    # Parse end data block
    enddat = []
    for line in lines[stopi-1:stopi+1]
        numbers = [parse(Float64, x) for x in split(line)]
        append!(enddat, numbers)
    end
    enddat = reshape(enddat, (length(enddat)÷2, 2))

    # Process wavelength and flux data
    wl = data[:, 1]
    fl = data[:, 2]
    
    # Process end data
    if size(enddat, 1) > 1
        wl = vcat(wl, enddat[:, 1])
        fl = vcat(fl, enddat[:, 2])
    else
        push!(wl, enddat[1,1])
        push!(fl, enddat[1,2])
    end
    
    println(wvl1)
    println(wvl2)
    
    # Return filtered data (commented out as in original)
    # mask = (wl .>= wvl1) .& (wl .<= wvl2)
    # return wl[mask], fl[mask]
    return wl, fl
end

if abspath(PROGRAM_FILE) == @__FILE__
    # Example usage:
    filename = ARGS[1]
    df = read__formal(filename)

    # Show the DataFrame (first 5 rows)
    println(first(df, 5))
end