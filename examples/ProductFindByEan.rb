require 'SyndicatePlusApi'

#initlze with Gem with Required Key

SyndicatePlusApi::Configuration.configure do |config|
  config.secret        = 'your-secret'
  config.key           = 'your-key'
  config.version = 'your-version'
end


include SyndicatePlusApi::Client

#Search Product By Ean

result  = getProductByEan(8711200189106)

#Here is the output Log
#=> #<Hashie::Mash Brand=#<Hashie::Mash Id=351 Name="Unox"> CategoryId=5 Description="" Id=5798 ImageUrl="http://syndicateplus.blob.core.windows.net/resources/products/images/634835794807955862_unox-sate.jpg" Manufacturer=#<Hashie::Mash Id=35 Name="Unilever Nederland B.V."> Name="Good Noodles Saté" Nutrition=[#<Hashie::Mash Id=1 Name="Energie" Units="Kcal" Value=210.0>, #<Hashie::Mash Id=2 Name="Suikers" Units="g" Value=2.9>, #<Hashie::Mash Id=3 Name="Vet" Units="g" Value=11.0>, #<Hashie::Mash Id=4 Name="Zout" Units="g" Value=1.07>, #<Hashie::Mash Id=5 Name="Verzadigd Vet" Units="g" Value=4.7>, #<Hashie::Mash Id=7 Name="Koolhydraten" Units="g" Value=26.0>, #<Hashie::Mash Id=8 Name="Eiwit" Units="g" Value=3.1>, #<Hashie::Mash Id=9 Name="Vezels" Units="g" Value=0.4>, #<Hashie::Mash Id=10 Name="Energie" Units="Kj" Value=890.0>] Retailers=[#<Hashie::Mash Id=6 Name="C1000">, #<Hashie::Mash Id=2 Name="Albert Heijn">, #<Hashie::Mash Id=17 Name="Jumbo">] SubCategoryId=69>


puts result.Id
# output result
#=> 5798

puts result.Name
# output result
#=> "Good Noodles Saté"
