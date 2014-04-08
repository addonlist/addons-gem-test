class Email
  include Mongoid::Document
  include Mongoid::Timestamps

  field :to, type: String
  field :from, type: String
  field :subject, type: String
  field :body, type: String
end
