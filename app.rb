require "sinatra"
require "aws-sdk-ec2"

# The AWS SDK will search for:
#   ENV[AWS_REGION]
#   ENV[AWS_ACCESS_KEY_ID]
#   ENV[AWS_SECRET_ACCESS_KEY]
#   ~/.aws/{credentials,config}

set :ec2, Aws::EC2::Resource.new
set :instance_id, ENV['AWS_INSTANCE_ID']

get "/" do
  ec2 = settings.ec2
  instance_id = settings.instance_id

  instance = ec2.instance instance_id
  @name = instance.tags.find { |tag| tag.key == "Name" }.value
  @state = instance.state.name
  @action = @state == "stopped" ? "start" : "stop"

  erb :index
end

post "/" do
  known_actions = ["start", "stop"]
  @action = params["action"]
  halt "Unknown action: '#{@action}'" unless known_actions.member? @action

  ec2 = settings.ec2
  instance_id = settings.instance_id

  instance = ec2.instance instance_id
  @state = instance.state.name

  halt "Invalid action: '#{@action}', when state is '#{@state}'" unless valid? @action, @state

  case @action
  when "start"
    instance.start
  when "stop"
    instance.stop
  end

  redirect "/"
end

def valid? action, state
  ( action == "start" && state == "stopped" ) || ( action == "stop" && state == "running" )
end

__END__

@@ index
<html>
  <head>
    <title>EC2 Instance Control</title>
  </head>

  <body>
    <p>
      If &quot;pending&quot; or &quot;stopping&quot;, then reload the page.
    </p>

    <p>
      The instance is either starting up (&quot;pending&quot;) or shutting down (&quot;stopping&quot;), which can take several minutes.
    </p>

    <hr>

    <p>
      <%= @name %>: <%= @state %>
    </p>

    <form method="post">
      <input type="submit" name="action" value="<%= @action %>">
    </form>
  </body>
</html>
