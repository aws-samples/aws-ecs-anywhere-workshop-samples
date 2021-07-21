FROM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum -y install httpd
COPY index.html /var/www/html/index.html
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
EXPOSE 80