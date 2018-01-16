class Lodger < Sublease::Lodger
  belongs_to_sublease(:tenant)
end
