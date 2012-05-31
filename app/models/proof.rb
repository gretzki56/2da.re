# require 'app/uploaders/proof_uploader'

class Proof
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :challenge
  belongs_to :user

  field :proof, type: Integer, default: 0
  field :comment, type: String

  embeds_many :proof_votes
  
  default_scope order_by([:created_at,:asc])

  mount_uploader :photo, ProofUploader
end
