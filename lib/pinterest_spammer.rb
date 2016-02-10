require 'mechanize'
require 'json'
class PinterestSpammer
  def sign_in(username, password)
    # 1. complete request params
    url = 'https://www.pinterest.com/resource/UserSessionResource/create/'
    data = {
      options: { username_or_email: username, password: password },
      context: {}
    }
    params = {
      source_url: '/login/',
      module_path: 'App()>LoginPage()>Login()>Button(class_name=primary, text=Log In, type=submit, size=large)',
      data: data.to_json
    }
    headers = default_headers
    headers['Cookie'] = 'csrftoken=1234;'
    headers['X-CSRFToken'] = '1234'

    # 2. make request
    agent = Mechanize.new
    result = agent.post(url, params, headers)

    # 3. return result
    { success: result.code.to_s == '200' }
  rescue StandardError => e
    { success: false, error_msg: e.message }
  end

  private

  def default_headers
    {
      'Host' => 'www.pinterest.com',
      'Accept' => 'application/json, text/javascript, */*; q=0.01',
      'Accept-Language' => 'en-US,en;q=0.5',
      'DNT' => '1',
      'Referer' => 'https://www.pinterest.com/',
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.104 Safari/537.36',
      'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
      'X-Pinterest-AppState' => 'active',
      'X-NEW-APP' => '1',
      'X-APP-VERSION' => '04cf8cc',
      'X-Requested-With' => 'XMLHttpRequest',
      'WWW-Authenticate' => 'Basic realm="myRealm"'
    }
  end
end
