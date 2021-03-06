package net.thucydides.core.reports;

import com.google.common.base.Optional;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import com.google.inject.Inject;
import net.thucydides.core.ThucydidesSystemProperty;
import net.thucydides.core.guice.Injectors;
import net.thucydides.core.model.TestOutcome;
import net.thucydides.core.reports.json.JSONTestOutcomeReporter;
import net.thucydides.core.reports.xml.XMLTestOutcomeReporter;
import net.thucydides.core.util.EnvironmentVariables;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.List;
import java.util.Locale;

/**
 * Loads test outcomes from a given directory, and reports on their contents.
 * This class is used for aggregate reporting.
 */
public class TestOutcomeLoader {

    private final EnvironmentVariables environmentVariables;
    private final OutcomeFormat format;

    public TestOutcomeLoader() {
        this(Injectors.getInjector().getInstance(EnvironmentVariables.class));
    }

    @Inject
    public TestOutcomeLoader(EnvironmentVariables environmentVariables) {
        this.environmentVariables = environmentVariables;
        format = getFormat();
    }

    /**
     * Load the test outcomes from a given directory.
     *
     * @param reportDirectory An existing directory that contains the test outcomes in XML or JSON format.
     * @return The full list of test outcomes.
     * @throws java.io.IOException Thrown if the specified directory was invalid.
     */
    public List<TestOutcome> loadFrom(final File reportDirectory) throws IOException {

        AcceptanceTestLoader testOutcomeReporter = getOutcomeReporter();

        List<File> reportFiles = getAllOutcomeFilesFrom(reportDirectory);

        List<TestOutcome> testOutcomes = Lists.newArrayList();
        for (File reportFile : reportFiles) {
            Optional<TestOutcome> testOutcome = testOutcomeReporter.loadReportFrom(reportFile);
            testOutcomes.addAll(testOutcome.asSet());
        }

        return ImmutableList.copyOf(testOutcomes);
    }


    private List<File> getAllOutcomeFilesFrom(final File reportsDirectory) throws IOException{
        File[] matchingFiles = reportsDirectory.listFiles(new SerializedOutcomeFilenameFilter());
        if (matchingFiles == null) {
            throw new IOException("Could not find directory " + reportsDirectory);
        }
        return ImmutableList.copyOf(matchingFiles);
    }

    public static TestOutcomes testOutcomesIn(final File reportsDirectory) throws IOException {
        TestOutcomeLoader loader = new TestOutcomeLoader();
        return TestOutcomes.of(loader.loadFrom(reportsDirectory));
    }

    public AcceptanceTestLoader getOutcomeReporter() {
        switch (format) {
            case XML: return new XMLTestOutcomeReporter();
            case JSON: return new JSONTestOutcomeReporter();
            default: throw new IllegalArgumentException("Unsupported report format: " + format);
        }
    }
    private OutcomeFormat getFormat() {
        String formatValue = ThucydidesSystemProperty.THUCYDIDES_REPORT_FORMAT
                .from(environmentVariables, OutcomeFormat.XML.toString());
        return OutcomeFormat.valueOf(formatValue.toUpperCase());
    }

    private class SerializedOutcomeFilenameFilter implements FilenameFilter {
        public boolean accept(final File file, final String filename) {
            return filename.toLowerCase(Locale.getDefault()).endsWith(getFormat().getExtension());
        }
    }
}
