require 'mechanize'
require 'json'
class PinterestSpammer
  attr_accessor :agent, :csrftoken

  def initialize
    @agent = Mechanize.new
  end

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
    result = @agent.post(url, params, headers)
    @agent.cookies.each do |c|
      if c.name == 'csrftoken'
        @csrftoken = c.value.to_s
      end
    end

    # 3. return result
    { success: result.code.to_s == '200' }
  rescue StandardError => e
    { success: false, error_msg: e.message }
  end

  def create_pin(board_id, link, image_url, description)
    # 1. complete request params
    url = 'https://www.pinterest.com/resource/PinResource/create/'
    data = {
      options: { board_id: board_id , description: description, link: link, image_url: image_url, method: "bookmarklet", is_video: nil },
      context: {}
    }
    params = {
      source_url: "/pin/create/bookmarklet/?url=#{link}",
      pinFave: 1,
      description: description,
      data: data.to_json,
      module_path: "module_path=App()>PinBookmarklet()>PinCreate()>PinForm(description=, default_board_id=null, show_cancel_button=true, cancel_text=Close, link=, show_uploader=false, image_url=, is_video=null, heading=Pick a board, pin_it_script_button=true)"
    }
    headers = default_headers
    headers['X-CSRFToken'] = @csrftoken

    # 2. make request
    result = @agent.post(url, params, headers)

    # 3. return result
    success = result.code.to_s == '200'
    if success
      result_body = JSON.parse(result.body)
      pin_id = result_body['resource_response']['data']['id']
    end
    { success:  success, pin_id: pin_id }
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
