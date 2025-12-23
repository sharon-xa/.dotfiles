function run-disown --wraps nohup --description "You can run and immediately disown a process"
    nohup $argv >/dev/null 2>&1 & disown
end
