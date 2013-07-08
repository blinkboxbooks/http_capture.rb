require 'net/http/capture'

shared_examples "capturing HTTP responses" do
    before :each do
        # Clear the captured requests
        HttpCapture::RESPONSES.clear
    end

    it 'should capture a Net::HTTP.get request' do
        # Do the request
        perform_get(make_test_uri())

        HttpCapture::RESPONSES.should have(1).item
    end

    context 'last captured response wrapper' do
        before :all do
            HttpCapture::RESPONSES.clear

            @actual = perform_get(make_test_uri(200,"text"))

            @res = HttpCapture::RESPONSES.last
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