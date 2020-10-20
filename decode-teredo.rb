#!/usr/bin/ruby
#
# Decode Teredo
#
# @j0hn__f
#
# Extracts server, flags, port, external address from a teredo address
#
# $ ruby decode-teredo.rb 2001:0:4136:e388:1c6c:2fd0:af50:9
#
addr = ARGV[0]

begin
array = addr.split(":")

# prefix
prefix = array[0]+array[1]


# server ipv4 addr
ipv4addr = array[2]+array[3]

firstOctet = ipv4addr[0..1].hex.to_i
secondOctet = ipv4addr[2..3].hex.to_i
thirdOctet = ipv4addr[4..5].hex.to_i
fourthOctet = ipv4addr[6..7].hex.to_i

# flags
flags = array[4]

# obscured external port
# gets XORed with 0xffff to remove obscuration
ePort = array[5].hex.to_i ^ 65535

# obscured external address
# each part gets XORed with 0xff to remove the obscuration
extAddr = array[6]+array[7]

octet1 = extAddr[0..1].hex.to_i ^ 255
octet2 = extAddr[2..3].hex.to_i ^ 255
octet3 = extAddr[4..5].hex.to_i ^ 255
octet4 = extAddr[6..7].hex.to_i ^ 255

# display the output
puts "TeredoServer:\t"+firstOctet.to_s+"."+secondOctet.to_s+"."+thirdOctet.to_s+"."+fourthOctet.to_s
puts "Flags:\t\t#{flags}"
puts "Port:\t\t#{ePort}"
puts "External Addr:\t"+octet1.to_s+"."+octet2.to_s+"."+octet3.to_s+"."+octet4.to_s

rescue
  puts "You entered an invalid Teredo address, it could not be decoded"
end
