require 'yaml'
# Load security group and subnet ids from BJC Test Kitchen
aws_networking = YAML.load_file(File.join(ENV['HOME'], 'cookbooks', 'bjc-ecommerce', '.kitchen.local.yml'))

# Load defaults from the global chef configuration 
eval File.open(File.join(ENV['HOME'], ".chef", "knife.rb")).read

knife[:region] = "us-west-2"
knife[:use_iam_profile] = true
knife[:ssh_key_name] = "chef_demo_2x"
knife[:identity_file] = File.join(ENV['HOME'], ".ssh", "id_rsa")
knife[:subnet_id] = aws_networking["driver"]["subnet_id"]
knife[:security_group_ids] = Array(aws_networking["driver"]["security_group_ids"])
