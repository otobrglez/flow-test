#!/usr/bin/env python

import smtplib
import subprocess

DOCKER_IMAGE = "databox/flow-test"
DATABOX_USER_EMAIL = "oto@databox.com"

MAIL_SENDER = 'otobrglez@gmail.com'
MAIL_RECEIVERS = ['oto+flow-test@databox.com', 'dev@databox.com']
MAIL_LOGIN = "otobrglez"
MAIL_PASS = "karkoli123"
SMTP_HOST = 'smtp.sendgrid.net'
SMTP_PORT = 587

def run_container():
  cmd = "docker run -e DATABOX_USER_EMAIL={0} -e MAX_WAIT_TIME=10 -i {1} rspec".format(DATABOX_USER_EMAIL, DOCKER_IMAGE)
  child = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE, shell=True)
  (out, err) = child.communicate()
  return_code = child.returncode
  return (return_code, out)

def send_mail(message):
  message = """From: Flow-test {0}
Subject: Databox Connect Platform: flow-test Error

{1}
""".format(MAIL_SENDER, message)

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

exit_code = run_container()

if __name__ == '__main__':
  past_run = run_container()
  if past_run[0] == 1:
    send_mail(past_run[1])
    print "Mail with error was successfuly sent!"
  else:
    print "Done."

