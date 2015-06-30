package org.gulltopp.rpg;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Created by Gulltopp on 30/06/2015.
 */
public class PowersGenerator {

    private static PowersGenerator instance;

    private PowersGenerator() {
    }

    public static void main(String[] args) throws TransformerException, IOException {
        instance = new PowersGenerator();
        instance.doGenerate();

    }

    private void doGenerate() throws TransformerException, IOException {

        TransformerFactory tFactory = TransformerFactory.newInstance();
        InputStream template = PowersGenerator.class.getClassLoader().getResourceAsStream("template/template.xsl");
        Transformer transformer = tFactory.newTransformer(new StreamSource(template));
        InputStream powers = PowersGenerator.class.getClassLoader().getResourceAsStream("in/file1.xml");

        Path file = Paths.get("out/powers.html");
        if(!Files.exists(file.getParent())){
            Files.createDirectories(file.getParent());
        }
        if(!Files.exists(file)) {
            Files.createFile(file);
        }
        transformer.transform(new StreamSource(powers), new StreamResult(Files.newBufferedWriter(file)));
    }
}

