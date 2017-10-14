#!/usr/bin/env ruby

def parse(fin="-")
    if fin == "-" then
        fread = $stdin
    else
        fread = File.new fin
    end
    lines = fread.readlines
    ptr = [0, 0] # [y, x]
    stack = []
    direction = [0, 1]
    suspend_move = false
    text_mode = false
    while true
        if text_mode
            if lines[ptr[0]][ptr[1]] == "\""
                text_mode = false
            else
                stack.push lines[ptr[0]][ptr[1]].ord
            end
        else
            #puts "#{ptr[0]} #{ptr[1]}: #{lines[ptr[0]][ptr[1]]}"
            case lines[ptr[0]][ptr[1]]
            when "0".."9"
                stack.push lines[ptr[0]][ptr[1]].to_i
            when "+"
                stack.push stack.pop + stack.pop
            when "-"
                little = stack.pop
                big = stack.pop
                stack.push big - little
            when "*"
                stack.push stack.pop * stack.pop
            when "/"
                little = stack.pop
                big = stack.pop
                stack.push (big / little).to_i
            when "%"
                little = stack.pop
                big = stack.pop
                stack.push (big % little)
            when "!"
                test = stack.pop
                if test == 0
                    stack.push 1
                else
                    stack.push 0
                end
            when "`"
                little = stack.pop
                big = stack.pop
                if big > little
                    stack.push 1
                else
                    stack.push 0
                end
            when ">"
                direction = [0, 1]
            when "<"
                direction = [0, -1]
            when "^"
                direction = [-1, 0]
            when "v"
                direction = [1, 0]
            when "?"
                test = rand 4
                if test == 0
                    direction = [0, 1]
                elsif test == 1
                    direction = [0, -1]
                elsif test == 2
                    direction = [-1, 0]
                elsif test == 3
                    direction = [1, 0]
                end
            when "_"
                test = stack.pop
                #suspend_move = true
                if test == 0 or test == nil
                    direction = [0, 1]
                else
                    direction = [0, -1]
                end
            when "|"
                test = stack.pop
                #suspend_move = true
                if test == 0 or test == nil
                    direction = [1, 0]
                else
                    direction = [-1, 0]
                end
            when "\""
                text_mode = true
            when ":"
                dup = stack.pop
                stack.push dup
                stack.push dup
            when "\\"
                little = stack.pop
                big = stack.pop
                stack.push big
                stack.push little
            when "$"
                stack.pop
            when "."
                print "#{stack.pop} "
            when ","
                print "#{stack.pop.chr}"
            when "p"
                x = stack.pop
                y = stack.pop
                val = stack.pop
                lines[y][x] = val
            when "g"
                x = stack.pop
                y = stack.pop
                stack.push lines[y][x]
            when "&"
                print "\nNO>"
                stack.push gets.to_i
            when "~"
                print "\nCH>"
                stack.push gets.to_s
            when "@"
                break
            end
        end
        if not suspend_move
            ptr[0] += direction[0]
            ptr[1] += direction[1]
        else
            suspend_move = false
        end
    end
end

def main
    fin = "-"

    if ARGV.first
        fin = ARGV.first
    end

    parse fin
end

if __FILE__ == $0
    main
end
