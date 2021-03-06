(use-modules (srfi srfi-64))
(include "nick-converter.scm")

(define test-msg ":r2tg!~user@static.213-239-215-115.clients.your-server.de PRIVMSG #radare :<Maijin> Just build using ./sys/asan.sh and paste log caused by your issue")

(define test-nonmsg ":aiju!~aiju@unaffiliated/aiju PRIVMSG #cat-v :branch_: a large part of modern human intelligence is learned through culture :)")

(define test-zv ":zv-test!43a46046@gateway/web/freenode/ip.67.164.96.70 PRIVMSG #test-channel :<Maijin> adfasfaf")

(define test-brackets ":r2tg!43a46046@gateway/web/freenode/ip.67.164.96.70 PRIVMSG #test-channel :<Maijin> ad< adfasdf >fasfaf")

(test-begin "Tests")

(test-begin "privmsg-modifier")

(test-equal (privmsg-modifier "" "" "freenode" test-zv)
  ":^Maijin!43a46046@gateway/web/freenode/ip.67.164.96.70 PRIVMSG #test-channel :adfasfaf")

(test-equal (privmsg-modifier "" "" "freenode" test-msg)
  ":^Maijin!~user@static.213-239-215-115.clients.your-server.de PRIVMSG #radare :Just build using ./sys/asan.sh and paste log caused by your issue")

(test-equal
    (privmsg-modifier "" "" "freenode" test-nonmsg)
  ":aiju!~aiju@unaffiliated/aiju PRIVMSG #cat-v :branch_: a large part of modern human intelligence is learned through culture :)")

(test-end "privmsg-modifier")


(test-begin "extract-gateway-components")

(test-equal (extract-gateway-fields "(freenode #radare r2tg <NICK>)")
  '("freenode" "#radare" "r2tg" "<NICK>"))

(test-equal (extract-gateway-fields "(* #radare r2tg <NICK>)")
  '("*" "#radare" "r2tg" "<NICK>"))

(test-equal (process-weechat-option "(freenode #radare r2tg <NICK>)" #t)
  '("freenode" . ":(r2tg)!\\S* PRIVMSG #radare :(<(\\S*?)>)"))

(test-end "extract-gateway-components")


;; gateway string splitting code
(test-begin "split-gateways")
(test-equal
    (split-gateways "(freenode #radare r2tg <NICK>)(* * slack-irc-bot NICK:)")
    '("(freenode #radare r2tg <NICK>)" "(* * slack-irc-bot NICK:)"))

(test-equal
    (split-gateways "(freenode #radare r2tg (NICK))(* * slack-irc-bot NICK:)")
  '("(freenode #radare r2tg (NICK))" "(* * slack-irc-bot NICK:)"))

(test-equal
    (split-gateways "(freenode #radare r2tg <NICK>)
(* * slack-irc-bot NICK:)")
  '("(freenode #radare r2tg <NICK>)" "(* * slack-irc-bot NICK:)"))
(test-end "split-gateways")



(test-end "Tests")
