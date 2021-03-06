require 'aws-sdk-s3'

class UploadService
  class << self
    BUCKET_FOLDER = 'dudeshub'
    IMAGE_EXT = '.svg'

    # https://docs.aws.amazon.com/AmazonS3/latest/dev/UploadObjSingleOpRuby.html
    # use second method from amazon docs if DudeGL will pass image as String
    def call(data, aws_fname)
      client = Aws::S3::Client.new(region: credentials(:region),
                                   secret_access_key: credentials(:secret_access_key),
                                   access_key_id: credentials(:access_key_id))

      @object_key = "#{BUCKET_FOLDER}/#{aws_fname}#{IMAGE_EXT}"
      s3 = Aws::S3::Resource.new(client: client)
      obj = s3.bucket(credentials(:aws_bucket)).object(@object_key)
      # upload string in I/O stream, avoiding need to save it locally as tmp file
      obj.put(body: data, content_type: "image/svg+xml")
      # make file public
      # https://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Client.html#put_object_acl-instance_method
      client.put_object_acl(bucket: credentials(:aws_bucket),
                            grant_read: "uri=http://acs.amazonaws.com/groups/global/AllUsers",
                            key: @object_key)
      s3_file_path
    end

    private

    def credentials(key)
      Rails.application.credentials[:aws][key]
    end

    def s3_file_path
      "https://#{credentials(:aws_bucket)}.s3-#{credentials(:region)}.amazonaws.com/#{@object_key}"
    end
  end
end
