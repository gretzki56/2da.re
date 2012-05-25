module Helpers
  def from_json file
    JSON.parse(File.read(Rails.root.join("spec","fixtures",file)))
  end
end