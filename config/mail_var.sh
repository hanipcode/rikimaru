BASE_PATH=/etc/rikimaru
MAIL_HEAD="From:hanif@mail.com
To:pocisite@gmail.com
Subject: Build Notification System
Content-Type: text/html"
MAIL_MSG=`cat $BASE_PATH/html/head.html`
MAIL_FOOTER=`cat $BASE_PATH/html/footer.html`