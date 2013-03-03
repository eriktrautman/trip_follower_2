Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "QVim65jLuVeoo7phUAP0AQ", "5tMM645CWOmHwZKcf8xbIVCbRhPHYzMAkmhwvwX7s"
  provider :instagram, "b50084b45ed94392a160fa31b0e7a488", "836aa4607ac24b5bb57af76dada1d604"
  provider :tumblr, "aX3GtjNdUNH8Q8ZUBoZ1HbrTBYh9acrIdbWd99qtu1M8RXx2NU", "pwJVt25o5QlcrV2Wq7TSpaCJhgzmMOR2hzYFpkwosWmcW1jYpE"
end