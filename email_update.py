import sys
import datetime
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from_addr = 'your_email@drexel.edu' # sender's email
to_addr = 'your_email@drexel.edu' # recipient's email 
subject = 'Whatever Subject You Like %s' % datetime.datetime.now()

# prepare HTML parts
html_header = """
<html>
<body>
<pre style="font: monospace">
<span class="inner-pre" style="font-size: 12px">
"""
html_footer = """
</span>
</pre>
</body>
</html>
"""
html_msg = ''
html_msg += html_header
for line in sys.stdin:
    html_msg += line 
html_msg += html_footer

# assemble the message
msg = MIMEMultipart('alternative')
msg['Subject'] = subject
msg['From'] = from_addr
msg['To'] = to_addr
msg.attach(MIMEText(html_msg, 'html'))
print('*************\nthis message: \n%s\n*************\n' % msg.as_string())

# send it out
mySMTP = smtplib.SMTP('smtp.mail.drexel.edu')
# mySMTP.set_debuglevel(1)
mySMTP.sendmail(from_addr, to_addr, msg.as_string())
mySMTP.quit()
