FROM python:3
COPY . /usr/src/app
WORKDIR /usr/src/app
ENV LINK http://www.meetup.com/nutanix/
ENV TEXT1: Calm 
ENV TEXT2: Jenkins Argo - GitOps Demo
ENV LOGO: nutahttps://raw.githubusercontent.com/jesse-gonzalez/simple-rsvp-app/master/static/nutanix.png
ENV COMPANY: Nutanix Inc.
RUN pip3 install -r requirements.txt
CMD python rsvp.py
