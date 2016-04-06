math.randomseed(os.time())

tags = { 'love', 'instagood', 'me', 'tbt', 'cute', 'follow', 'followme', 'photooftheday', 'happy', 'tagforlikes', 'beautiful', 'girl', 'like', 'selfie', 'picoftheday', 'summer', 'fun', 'smile', 'friends', 'like4like', 'instadaily', 'fashion', 'igers', 'instalike', 'food' }

path  = "/track"
wrk.headers["Content-Type"] = "application/x-www-form-urlencoded"
wrk.method = "POST"

request = function()
  wrk.body = "hashtag=" .. tags[ math.random( #tags ) ]
  return wrk.format("POST", path)
end
