# Use an official Dart runtime as a parent image
FROM google/dart

# Set the working directory to the root of the project
WORKDIR /app

# Copy the pubspec file and get dependencies
COPY pubspec.* ./
RUN pub get

# Copy the rest of the project files
COPY . .

# Build the project
RUN flutter build apk

# Expose the port that the app runs on
EXPOSE 8080

# Start the app
CMD ["flutter", "run", "--release", "--no-sound-null-safety", "--dart-define=FLUTTER_WEB_USE_SKIA=true", "--host=0.0.0.0", "--port=8080"]