using JSON
using FilePaths

function foo()
    source_dir = "/Users/maddy/proj/julia/coarse-to-fine-synthesis"
    target_dir = "PluckArtifact-synthesis/"
    
    # Create target directory if it doesn't exist
    mkpath(target_dir)
    
    open("PluckArtifact-synthesis/data/figure5/historical_nov14.json") do f
        data = JSON.parse(f)
        for group in data["groups"]
            if haskey(group, "runs")
                println("Task: ", get(group["config"], "task", "unknown"))
                
                # Handle each run
                for run in group["runs"]
                    mode = run["mode"]
                    path = dirname(run["path"])
                    
                    # Remove leading slash if present
                    path = startswith(path, "/") ? path[2:end] : path
                    
                    source = joinpath(source_dir, path)
                    target = joinpath(target_dir, path)
                    
                    mkpath(dirname(target))
                    Base.Filesystem.cptree(source, target, force=true)
                    println("  Copied $mode run from: ", source)
                    println("  To: ", target)
                end
                
                println()
            end
        end
    end
end

foo()
