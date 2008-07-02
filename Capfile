role :main, "juozas@23we.com"
set :app, "catabuzz"
set :source, "~/Sites/#{app}_app/source"

def parse_branch_list(data)
  # find something that looks like this:
  #* master
  re = /\*\s(.*)/
  data.each_line do |l|
    md = re.match(l)
    return md[1] if md
  end
    
  return nil
end

def choose_tag_from_menu
  puts "1. " + available_tags[:latest]
  puts "----------"
  available_tags[:all].each_with_index { |tag, i| puts "#{i + 2}. #{tag}"}
  answer = Capistrano::CLI.ui.ask("Which tag to release: ", Integer) do |question|
    question.default = 1
    question.above = 0
    question.below = available_tags[:all].size + 2
  end
  
  return available_tags[:latest] if answ == 1
  
end

task :get_checkedout_branch do
  run("cd #{source} && git branch") do |ssh, mode, data| 
    set :checkedout_branch, parse_branch_list(data) if mode == :out
  end
end

task :checkout_deployment_branch do
  run("cd #{source} && git checkout deployment")
end

task :pull_source do
  get_checkedout_branch
  checkout_deployment_branch if checkedout_branch != "deployment"
  
  run("cd #{source} && git pull")
  puts hs.inspect
end

desc "Returns the latest and all release tags"
task :get_available_tags do
  # find latests tag
  latest = ""
  run("cd #{source} && git describe --tags --abbrev=0 HEAD") do |ssh, mode, data|
    latest = data.strip if mode == :out
  end
  # find all tags
  all = []
  run("cd #{source} && git tag") do |ssh, mode, data|
    data.each_line { |l| all << l.strip} if mode == :out
  end
  
  set :available_tags, {:latest => latest, :all => all}
end

task :select_tag do
  # temporary get tags
  get_available_tags
  
  set :selected_tag, choose_tag_from_menu
  
  puts selected_tag.inspect
end
    


