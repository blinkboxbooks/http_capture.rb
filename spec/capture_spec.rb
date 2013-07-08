require 'net/http/capture'

shared_examples "capturing HTTP responses" do
    before :each do
        # Clear the captured requests
        Net::Captured::RESPONSES.clear
    end

    it 'should capture a Net::HTTP.get request' do
        # Do the request
        perform_get("http://www.ietf.org/rfc/rfc0822.txt")

        Net::Captured::RESPONSES.should have(1).item
    end

    context 'captured request' do
        before :all do
            immediate = perform_get("http://www.ietf.org/rfc/rfc0822.txt")
            @res = Net::Captured::RESPONSES.first
        end
        
        it 'should return headers with the #[](key) method' do
            @res['Content-Length'].should be_a(String)
        end

        it 'should return the HTTP status with the #status method' do
            @res.status.should == 200
        end

        it 'should return the HTTP body with the #body method' do
            @res.body.should == "text"
        end
    end
end