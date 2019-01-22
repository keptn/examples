FROM openjdk:8-jdk-alpine
 
RUN wget http://mirror.nbtelecom.com.br/apache/jmeter/binaries/apache-jmeter-4.0.tgz
RUN tar -xvzf apache-jmeter-4.0.tgz
RUN rm apache-jmeter-4.0.tgz

RUN mv apache-jmeter-4.0 /jmeter

# Copy all our jmeter scripts to the local scripts directory
COPY /scripts /scripts

ENV JMETER_HOME /jmeter

# Add JMeter to the Path
ENV PATH $JMETER_HOME/bin:$PATH
