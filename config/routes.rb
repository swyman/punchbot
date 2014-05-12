Rails.application.routes.draw do

  root 'punchbot#hello'

  post 'receive' => 'punchbot#receive_msg', as: :receive_msg
  post 'send' => 'punchbot#send_msg', as: :send_msg

  post 'exec' => 'punchbot#bot_exec', as: :bot_exec

  # admin
  post 'admin' => 'admin#admin', as: :admin

end
