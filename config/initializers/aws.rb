require "aws-sdk"

Aws.config.update(
  endpoint: ENV["S3_Endpoint"],
  access_key_id: ENV["S3_User_Name"],
  secret_access_key: ENV["S3_SECRET_KEY"],
  force_path_style: true,
  region: "us-east-1"
)

if ["test"].include? ENV["RAILS_ENV"]
  $s3 = Aws::S3::Client.new(stub_responses: true)
else
  $s3 = Aws::S3::Client.new
end
