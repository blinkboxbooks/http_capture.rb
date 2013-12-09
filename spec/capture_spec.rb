require 'net/http/capture'

shared_examples "capturing HTTP responses" do
  before :each do
    # Clear the captured requests
    HttpCapture::RESPONSES.clear
  end

  it 'should capture a HTTP GET request' do
    # Do the request
    perform_get(make_test_uri())

    # Really I should check that it has exactly 1 item, but for now we're happy that something comes through.
    HttpCapture::RESPONSES.length.should > 0
  end

  context 'last captured response wrapper' do
    before :all do
      HttpCapture::RESPONSES.clear
      perform_get(make_test_uri(200, "text"))
      @it = HttpCapture::RESPONSES.last
    end
    
    it 'should capture the request that triggered the response' do
      expect(@it.request).to_not be_nil
    end
    
    it 'should record the time it took to get the response with the #duration method' do
      expect(@it.duration).to be > 0
    end
    
    it 'should return headers with the #[](key) method' do
      expect(@it['Content-Length']).to be_a_kind_of(String)
    end

    it 'should support enumerating the headers with the #each method' do
      @it.each { |item| expect(item).to be_a_kind_of(Array) }
    end

    it 'should return the status with the #status method' do
      expect(@it.status).to eq(200)
    end

    it 'should return the body with the #body method' do
      expect(@it.body).to eq("text")
    end
  end

  context('last captured request wrapper') do
    before :all do
      HttpCapture::RESPONSES.clear
      perform_get(make_test_uri(200, "text"))
      @it = HttpCapture::RESPONSES.last.request
    end

    it 'should return the method with the #method method' do
      expect(@it.method).to eq("GET")
    end

    it 'should return the path with the #path method' do
      expect(@it.path).to_not be_nil # TODO: This should be a stronger check...
    end

    it 'should return the full URI with the #uri method' do
      expect(@it.uri).to be_a_kind_of(URI)
    end
  end  
end