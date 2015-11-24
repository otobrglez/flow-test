#!/usr/bin/env python

import smtplib
import subprocess
import urllib2
import urllib

DOCKER_IMAGE = "databox/flow-test"
MAIL_SENDER = 'oto+flow-test@databox.com'
MAIL_RECEIVERS = ['oto+flow-test@databox.com', 'dev@databox.com']
MAIL_LOGIN = "dbox_report"
MAIL_PASS = "0pridiKoNeDelas"
SMTP_HOST = 'smtp.sendgrid.net'
SMTP_PORT = 587

def run_container():
  cmd = "docker run -v `pwd`:/usr/src/app -e DATABOX_USER_EMAIL=dd@dd.com -e MAX_WAIT_TIME=10 -i {0} rspec".format(DOCKER_IMAGE)
  child = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE, shell=True)
  (out, err) = child.communicate()
  return_code = child.returncode
  return (return_code, out, err)

def send_mail(message, err=""):
  message = """From: Flow-test {0}
Subject: Databox Connect Platform: flow-test Error

{1}
---
{2}
""".format(MAIL_SENDER, message, err)

  try:
    smtp = smtplib.SMTP()
    smtp.connect(SMTP_HOST, SMTP_PORT)
    smtp.login(MAIL_LOGIN, MAIL_PASS)
    smtp.sendmail(MAIL_SENDER, MAIL_RECEIVERS, message)
    smtp.quit()
  except Exception, e:
    print e
    print "Error: unable to send email"
    raise e

def send_rest_mail(message, err=""):
  values = {}
  values['from'] = MAIL_SENDER
  values['to'] = MAIL_RECEIVERS
  values['subject'] = "Databox Connect Platform: flow-test Error"
  values['api_user'] = MAIL_LOGIN
  values['api_key'] = MAIL_PASS

  values['text'] = """####    Flow-test report    ####
{0}
---
{1}
""".format(message, err)


  url = "https://api.sendgrid.com/api/mail.send.json"
  data = urllib.urlencode(values, True)
  req = urllib2.Request(url, data)

  try:
    response = urllib2.urlopen(req)
    print response.read()
  except Exception as e:
    print "Error ~> "
    error_message = e.read()
    print error_message
    raise e

exit_code = run_container()

if __name__ == '__main__':
  past_run = run_container()
  if past_run[0] == 1:
    send_rest_mail(past_run[1], past_run[2])
    print "Mail with error was successfuly sent!"
  else:
    print "Done."

