CITIES = [
  {
    name: 'Pune'
  },
  {
    name: 'Jabalpur'
  }
]

ActiveRecord::Base.transaction do
  CITIES.each do |city|
    City.find_or_create_by!(name: city[:name])
  end
end
