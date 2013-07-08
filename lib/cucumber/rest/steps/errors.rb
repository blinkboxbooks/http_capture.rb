Then(/^the request (?:is|was) successful$/) do  
  last_response.code.should be_between 200, 299
end

Then(/^the response indicates that the request (?:is|was) invalid$/)
  last_response.code.should == 400
end

Then(/^the response indicates that the (?:.+) (?:is|was) not found$/)
  last_response.code.should == 404
end