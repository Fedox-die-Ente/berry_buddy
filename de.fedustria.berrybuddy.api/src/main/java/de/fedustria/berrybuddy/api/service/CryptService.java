package de.fedustria.berrybuddy.api.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.spec.KeySpec;
import java.util.Base64;
import java.util.Optional;

public class CryptService {
    private static final Logger           LOG                      = LoggerFactory.getLogger(CryptService.class);
    private static final String           DESEDE_ENCRYPTION_SCHEME = "DESede";
    private static final String           UNICODE_FORMAT           = "UTF8";
    private              byte[]           arrayBytes;
    private              SecretKey        key;
    private              KeySpec          ks;
    private              SecretKeyFactory skf;
    private              Cipher           cipher;
    private              String           myEncryptionKey;
    private              String           myEncryptionScheme;

    public CryptService(final String encryptionKey) {
        try {
            myEncryptionKey = encryptionKey;
            myEncryptionScheme = DESEDE_ENCRYPTION_SCHEME;
            arrayBytes = myEncryptionKey.getBytes(UNICODE_FORMAT);
            ks = new DESedeKeySpec(arrayBytes);
            skf = SecretKeyFactory.getInstance(myEncryptionScheme);
            cipher = Cipher.getInstance(myEncryptionScheme);
            key = skf.generateSecret(ks);
        } catch (final Exception e) {
            LOG.error("Failed to initialize CryptService", e);
        }
    }

    public String encrypt(final String unencryptedString) {
        try {
            cipher.init(Cipher.ENCRYPT_MODE, key);
            final byte[] plainText = unencryptedString.getBytes(UNICODE_FORMAT);
            final byte[] encryptedText = cipher.doFinal(plainText);

            return Base64.getEncoder().encodeToString(encryptedText);
        } catch (final Exception e) {
            LOG.error("Failed to encrypt string", e);
        }
        return unencryptedString;
    }

    public Optional<String> decrypt(final String encryptedString) {
        try {
            cipher.init(Cipher.DECRYPT_MODE, key);
            final byte[] encryptedText = Base64.getDecoder().decode(encryptedString);
            final byte[] plainText = cipher.doFinal(encryptedText);

            return Optional.of(new String(plainText, StandardCharsets.UTF_8));
        } catch (final Exception e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

}
