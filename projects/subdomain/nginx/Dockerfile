FROM nginx:latest

# Create log files for app.help-desk
ADD . /var/log/nginx/app.help-desk

RUN touch /var/log/nginx/app.help-desk/access.log
RUN touch /var/log/nginx/app.help-desk/error.log

# Create log files for help-desk
ADD . /var/log/nginx/help-desk

RUN touch /var/log/nginx/help-desk/access.log
RUN touch /var/log/nginx/help-desk/error.log

EXPOSE 80
