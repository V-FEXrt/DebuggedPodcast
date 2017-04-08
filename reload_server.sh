ps aux | grep App
# Kill old process
vapor build --release
# probably rm Data/database.sqlite
.build/release/App serve --env=production &
