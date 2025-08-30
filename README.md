# README

# Image Gallery App

A Ruby on Rails photo gallery application where users can create galleries and upload photos. Built with user authentication, photo management, and a slideshow feature.

## What This App Does

Anyone can browse galleries on the website, but you need to register to create your own galleries and upload photos. Each user can only manage their own galleries and photos.

When viewing a gallery, you see thumbnail images. Click any thumbnail to view the full-size photo, or use the slideshow mode to automatically cycle through all photos.

## Requirements Completed

**Mandatory Features:**
- User registration and login (email + password)
- Create, edit, and delete galleries (owners only)
- Upload, edit, and delete photos within galleries
- Thumbnail generation for fast loading
- Gallery view with clickable thumbnails
- Full image display
- Proper access control throughout

**Extra Features Added:**
- Slideshow mode with auto-advance, manual controls, and keyboard shortcuts
- Custom error pages (404, 422, 500) with consistent styling
- Docker setup for easy deployment

## Tech Stack

**Backend:**
- Ruby 3.2.2
- Rails 8.0.2
- PostgreSQL database

**Key Gems:**
- Devise for user authentication
- CanCanCan for authorization
- image_processing + mini_magick for photo thumbnails
- Bootstrap for styling
- RSpec + Factory Bot for testing

## Running the Application

**Prerequisites:**
- Ruby 3.2.2
- PostgreSQL
- ImageMagick

**Setup:**
```bash
git clone [repository-url]
cd image_gallery_app
bundle install
rails db:create db:migrate
rails server
```

Visit http://localhost:3000

## Slideshow Features

The slideshow was the most complex part to build. It includes:

- Auto-advancing slideshow (3 second intervals)
- Play/pause controls
- Manual navigation with arrow buttons
- Keyboard controls (arrow keys, spacebar, escape)
- Progress bar showing timing
- Thumbnail strip for quick navigation
- Fullscreen mode
- Auto-hiding controls during playback

The implementation uses vanilla JavaScript to avoid unnecessary dependencies and keep things fast.

## Testing

Comprehensive test suite using RSpec covering:
- All controller actions and authorization logic
- User authentication flows
- Gallery and photo management
- Access control for different user types

Run tests with: `rails db:test:prepare && rspec`

## Architecture Decisions

**Why Rails?** Fast development with good conventions for this type of CRUD application. Active Storage makes image handling straightforward.

**Why PostgreSQL?** More production-ready than SQLite, better for deployments.

**Why Devise + CanCanCan?** Tried and tested authentication/authorization stack that's easy to implement correctly.

**Why vanilla JavaScript for slideshow?** Wanted full control over the behavior without adding framework overhead. The slideshow logic is complex enough that a library might get in the way.

## Performance Considerations

- Thumbnail images are precomputed using Active Storage variants
- Database queries use includes() to avoid N+1 problems
- Slideshow images use lazy loading
- Controllers eager load associated records

## Error Handling

Custom error pages replace Rails default error screens:
- 404: Friendly "Gallery not found" message
- 422: Helpful validation error guidance  
- 500: Professional server error page

All styled with Bootstrap to match the main application.

## Docker Setup

Complete Docker configuration included but couldn't test locally due to macOS compatibility (Docker Desktop requires macOS 13+, running macOS 12.5).

Files provided:
- `Dockerfile` - Development setup
- `Dockerfile.production` - Multi-stage production build
- `docker-compose.yml` - Rails + PostgreSQL services
- `docker-entrypoint.sh` - Database setup automation

Should work with: `docker-compose up --build`

## Security

- All routes properly protected with authentication where needed
- Authorization checks ensure users can only manage their own content
- Draft galleries are only visible to owners
- Form submissions include CSRF protection
- File uploads validated and processed safely

## Code Organization

Models handle business logic like authorization (`can_be_viewed_by?`, `owner?` methods). Controllers focus on request handling. Views are kept simple with logic pushed down to models or helpers where appropriate.

The authorization logic is tested thoroughly since it's critical for security.

## Known Limitations

- No bulk photo upload (single file at a time)
- No image cropping interface (would be nice to have)
- Slideshow timing is fixed (could be user-configurable)

## Production Deployment

The production Dockerfile includes asset precompilation and is set up for container deployment. Environment variables would need to be configured for database connection, secret keys, etc.

Image uploads use Active Storage which can be configured for cloud storage providers in production.