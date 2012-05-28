class Proof
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :challenge
  belongs_to :user

  field :proofs, type: Integer, default: 0

  embeds_many :proof_votes


end
