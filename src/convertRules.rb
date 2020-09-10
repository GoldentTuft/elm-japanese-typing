# coding: UTF-8

#  nextInputのあるルールを展開する

def escape(s)
  if s == "\"" or s == "\\" then
    return "\\" + s
  else
    return s
  end
end

originalRomanRules = []
developRules = []
simpleRules = []
finishRules = []
open("inputRomanRules.txt", "r:utf-8") {|f|
  f.each_line {|line|
    originalRomanRules.push line.split
  }
}
simpleRules = originalRomanRules.select {|rule| rule.length == 2}
developRules = originalRomanRules.select {|rule| rule.length == 3}
developRules.each {|drule|
  simpleRules.each {|srule|
    if srule[0].start_with?(drule[2]) then
      finishRules.push [drule[2] + srule[0], drule[1] + srule[1] ]
    end
  }
}

finishRules = simpleRules + finishRules
open("inputEtcRules.txt", "r:utf-8") {|f|
  f.each_line {|line|
    finishRules.push line.split
  }
}
finishRules.push([" ", " "]) # これは手動追加

open("outputRules.txt", "w") {|f|
  finishRules.each {|rule|
    input = escape rule[0]
    output = escape rule[1]
    if input == "lltsu" or input == "xxtsu" then
      # これはだめだ
      next
    end
    f.puts ", Rule \"#{input}\" \"#{output}\" 0"
  }
}
