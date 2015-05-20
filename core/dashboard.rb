
def printModuleCount(mod)
  cmd="ls #{mod}|wc -l|sed 's/\\n//g'"
  c = `#{cmd}`
  return c.gsub(/\s+/, "")
end
