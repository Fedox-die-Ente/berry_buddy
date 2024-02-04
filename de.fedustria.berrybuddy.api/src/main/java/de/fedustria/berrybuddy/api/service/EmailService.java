package de.fedustria.berrybuddy.api.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.javamail.JavaMailSenderImpl;

import java.util.Arrays;
import java.util.Properties;

import static de.fedustria.berrybuddy.api.utils.Constants.*;

public class EmailService {
    private static final Logger             LOG = LoggerFactory.getLogger(EmailService.class);
    private final        JavaMailSenderImpl mailSender;
    private final        String             sender;

    public EmailService(final Properties props) {
        this.mailSender = new JavaMailSenderImpl();

        mailSender.setHost(props.getProperty(MAIL_HOST));
        mailSender.setPort(Integer.parseInt(props.getProperty(MAIL_PORT)));

        this.sender = props.getProperty(MAIL_USER);
        mailSender.setUsername(props.getProperty(MAIL_USER));
        mailSender.setPassword(props.getProperty(MAIL_PASS));

        final Properties mailProps = mailSender.getJavaMailProperties();
        mailProps.put("mail.transport.protocol", props.getProperty(MAIL_PROTOCOL, "smtp"));
        mailProps.put("mail.smtp.auth", props.getProperty(MAIL_AUTH, "true"));
        mailProps.put("mail.smtp.starttls.enable", props.getProperty(MAIL_STARTTLS, "true"));
        mailProps.put("mail.debug", props.getProperty(MAIL_DEBUG, "false"));
    }

    public void sendEmail(final String[] to, final String subject, final String text) throws MessagingException {
        final MimeMessage message = mailSender.createMimeMessage();

        message.setFrom(new InternetAddress(sender));

        Arrays.stream(to).forEach(t -> {
            try {
                message.addRecipients(MimeMessage.RecipientType.TO, t);
            } catch (final MessagingException e) {
                LOG.error("Could not add recipient " + t, e);
            }
        });

        message.setSubject(subject);
        message.setContent(text, "text/html; charset=utf-8");

        mailSender.send(message);
    }
}
