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
import java.util.Collection;
import java.util.regex.Pattern;

/**
 * Created by Gulltopp on 30/06/2015.
 */
public class PowersGenerator {

    private static PowersGenerator instance;
    private static Pattern  pattern = Pattern.compile(".*powers\\.xml");

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
        Collection<String> list = ResourceList.getResources(pattern);
        for(String fileName : list) {

            Path inputFile = Paths.get(fileName);
            InputStream powers = Files.newInputStream(inputFile);
            System.out.println("Processing file "+inputFile);
            Path file = Paths.get("out/"+inputFile.getFileName()+ ".html");
            if(!Files.exists(file.getParent())){
                Files.createDirectories(file.getParent());
            }
            if(!Files.exists(file)) {
                Files.createFile(file);
            }
            transformer.transform(new StreamSource(powers), new StreamResult(Files.newBufferedWriter(file)));
        }



    }
}

