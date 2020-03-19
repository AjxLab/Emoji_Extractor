# -*- coding: utf-8 -*-
Bundler.require
require './scraping'
require './model'
require './mailer'


START_TIME = Time.new
URL = 'http://www.example.com/'
$logger = Logger.new('log/develop.log')
$account = YAML.load_file('config/mail.yml')
$model = Model.new(YAML.load_file('config/db.yml')['file'])


def crawl(delay: 3, depth_limit: nil, multi: false, exit_all: true, error_alert: false, echo_bar: true)
  ## -----*----- クローリング -----*----- ##
  # delay：Float --> アクセス間隔
  # depth_limit：Int --> クロールする深さ
  # multi：Bool --> 並列処理(true) or 逐次処理(false)
  # exit_all：Bool --> エラーが発生した場合に，全てのタスクを終了

  # ターゲットURLを指定（Array）
  urls = [URL]

  task = Proc.new { |url|
    begin
      agent = Husc.new(url)

      # スクレイピング
      scraping(agent, delay: delay, depth_limit: depth_limit)
    rescue => e
      $logger.error(e.to_s)
      send_mail($account[:receive][:address], 'エラー発生', e.to_s)  if error_alert
      footer_exit(status: 1)  if exit_all
    end
  }

  if multi
    # 並列処理 ==================================
    threads = urls.map { |url|
      Thread.new {
        task.call(url)
      }
    }

    tw = ThreadsWait.new(*threads)
    mdap(urls.length, echo_bar: echo_bar) {tw.next_wait}
  else
    # 逐次処理 ==================================
    mdap(urls.length, echo_bar: echo_bar) { |i|
      task.call(urls[i])
      sleep delay
    }
  end
end


def footer_exit(status: 0)
  ## -----*----- EXIT -----*----- ##
  puts ""
  puts ""
  puts "----------------------------------------------------------------------"
  puts sprintf("Ran #{status} #{$0} in %5.3fs", Time.new - START_TIME)
  puts ""
  if status==0
    puts "\e[32mOK\e[0m"
  else
    puts "\e[31mERROR\e[0m"
  end

  yield  if block_given?

  exit status
end



if __FILE__ == $0
  crawl(multi: true, exit_all: false)
  footer_exit
end

