role :main, "juozas@23we.com"
set :app, "catabuzz"
set :source, "~/Sites/#{app}_app/source"
set :releases, "~/Sites/#{app}_app/releases"
set :deploy_configs, "~/Sites/#{app}_app/deploy_configs"

# skip the question of which tag to deploy. just use the latest instead
set :use_latest, false

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

def choose_tag_to_release
  return available_tags[:latest] if use_latest
  
  puts "1. " + available_tags[:latest]
  puts "----------"
  available_tags[:all].each_with_index { |tag, i| puts "#{i + 2}. #{tag}"}
  answer = Capistrano::CLI.ui.ask("Which tag to release: ", Integer) do |question|
    question.default = 1
    question.above = 0
    question.below = available_tags[:all].size + 2
  end
  
  return available_tags[:latest] if answer == 1
  return available_tags[:all][answer - 2]
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
end

# Returns the latest and all release tags
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

set(:selected_tag) do
  pull_source
  get_available_tags
  choose_tag_to_release
end

desc "Select a tag and create a folder containing the tagged release"
task :download_release do
  tag = selected_tag
  run "cd #{releases} && rm -rf #{tag} && mkdir -p #{tag}"
  run "cd #{source} && git archive #{tag} | (cd #{releases}/#{tag} && tar -xf -)"
end

desc "Copy mailer and db confings. Add REVISION and VERSION files"
task :config_release do
  tag = selected_tag
  run "cp -f #{deploy_configs}/*.yml #{releases}/#{tag}/config"
  run "echo #{tag} > #{releases}/#{tag}/REVISION"

  version = tag
  if md= /\d+(\.\d+)*\w*$/.match(tag)
    version = md[0].inspect
  end
  run "echo #{version} > #{releases}/#{tag}/VERSION"
end


task :link_release do
  tag = selected_tag
end
    


