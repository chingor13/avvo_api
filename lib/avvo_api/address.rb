# Represents an address. One of the following attributes MUST
# be set when using this model:
# 
# * doctor_id
# * lawyer_id
#
# This model has the following attributes:
#
# * id
# * address_line1
# * address_line2
# * city
# * state
# * postal_code
# * latitude
# * longitude
# 
class AvvoApi::Address < AvvoApi::Base
  belongs_to :lawyer
  belongs_to :doctor
  has_many :phones

  # Returns the 'main' address associated with the passed in
  # professional. This is usually the address you want to
  # use. +params+ is a hash of <tt>{:lawyer_id => lawyer.id}</tt> or
  # <tt>{:doctor_id => doctor.id}</tt>
  def self.main(params)
    response = self.get(:main, params)
    if response && response["id"]
      new(params.merge(response))
    elsif response && response["address"]
      new(params.merge(response["address"]))
    end
  end
end
