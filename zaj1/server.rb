#!/usr/bin/env ruby

#
# Server, ktory odbiera dane i odszyfrowuje wiadmosc
#
# Created: Marcin Wozniak
# Last edit: 09-10-2019
#

require 'openssl'
require 'socket'

def putsAllThingsWithIV
  puts ""
  puts "-----------------------------------------------------"
  puts "Decrypt: " + $mode 
  puts "IV: " + $iv
  puts "Key: " + $key
  puts "Message: " + $message
  puts ""
  puts "Decrypted message: " + $decrypted
  puts "-----------------------------------------------------"
end  

def putsAllThingsOutWithIV
  puts "-----------------------------------------------------"
  puts "Decrypt: " + $mode
  puts "Key: " + $key
  puts "Message: " + $message
  puts ""
  puts "Decrypted message: " + $decrypted
  puts "-----------------------------------------------------"
end

while true
  server = TCPServer.open(3000)
  client = server.accept 
  
  $mode = client.gets.gsub(/\n$/, '')
  
  if $mode == "des-ecb"
    $key = [client.gets.gsub(/\n$/, '')].pack("B*")
    $message = [client.gets.gsub(/\n$/, '')].pack("B*")
  
    d = OpenSSL::Cipher.new('des-ecb')
    d.decrypt
    d.key = $key.gsub(/\n$/, '')
    $decrypted = d.update($message.gsub(/\n$/, '')) + d.final 
  
    putsAllThingsOutWithIV
  
  elsif $mode == "3des-cbc" 
    $iv = [client.gets.gsub(/\n$/, '')].pack("B*")
    $key = [client.gets.gsub(/\n$/, '')].pack("B*")
    $message = [client.gets.gsub(/\n$/, '')].pack("B*")
  
    d = OpenSSL::Cipher.new('DES-EDE3-CBC')
    d.decrypt
    d.iv = $iv.gsub(/\n$/, '')
    d.key = $key.gsub(/\n$/, '')
    $decrypted = d.update($message.gsub(/\n$/, '')) + d.final 
    
    putsAllThingsWithIV
    
  elsif $mode == "aes-cbc-192" 
    $iv = [client.gets.gsub(/\n$/, '')].pack("B*")  
    $key = [client.gets.gsub(/\n$/, '')].pack("B*")
    $message = [client.gets.gsub(/\n$/, '')].pack("B*")
  
    d = OpenSSL::Cipher::AES.new(192, 'CBC')
    d.decrypt
    d.iv = $iv.gsub(/\n$/, '')
    d.key = $key.gsub(/\n$/, '')
    $decrypted = d.update($message.gsub(/\n$/, '')) + d.final 
    
    putsAllThingsWithIV
  
  elsif $mode == "rc5-ecb" 
    $key = [client.gets.gsub(/\n$/, '')].pack("B*") 
    $message = [client.gets.gsub(/\n$/, '')].pack("B*")
  
    d = OpenSSL::Cipher.new('RC5-ECB')
    d.decrypt
    d.key = $key.gsub(/\n$/, '')
    $decrypted = d.update($message.gsub(/\n$/, '')) + d.final 
    
    putsAllThingsOutWithIV
    
  elsif $mode == "idea-ofb" 
    $iv = [client.gets.gsub(/\n$/, '')].pack("B*")
    $key = [client.gets.gsub(/\n$/, '')].pack("B*") 
    $message = [client.gets.gsub(/\n$/, '')].pack("B*")
  
    d = OpenSSL::Cipher.new('idea-ofb')
    d.decrypt
    d.iv = $iv.gsub(/\n$/, '')
    d.key = $key.gsub(/\n$/, '')
    $decrypted = d.update($message.gsub(/\n$/, '')) + d.final 
    
    putsAllThingsWithIV
  
  end
  server.close
end
