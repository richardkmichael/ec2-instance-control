## Usage

1. Create a dedicated IAM Policy; see the [example](/iam_policy.json).
2. Create a a dedicated user and apply the policy.
3. Obtain the credential pair for the user, and store them in the environment to be found by the AWS SDK.
4. Store the instance ID in the environment as `AWS_INSTANCE_ID`.
5. Install the dependencies.
6. Start the app at an anonymous URL of your choice.

```
bundle install

export AWS_REGION=<YOUR_AWS_REGION>
export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY>
export AWS_SECRET_ACCESS_KEY=<YOUR_SECRET_ACCESS_KEY>

export AWS_INSTANCE_ID=<YOUR_INSTANCE_ID>

bundle exec ruby app.rb
```

## TODO

1. Remove the 1996 theme.
2. Autodiscover and handle multiple instances.
