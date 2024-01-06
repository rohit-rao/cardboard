#!/bin/sh

# Run any necessary DB migrations. This will run one per spinup, which is
# overkill, but there's no way to run post-deploy actions on the free tier.
# Comment out as an optimization if you know the DB schema has not changed.
#python manage.py migrate

# Comment out as an optimization after the admin email is set once.
#LIGHTLY_SANITIZED_EMAIL=${PUZZBOARD_ADMIN_EMAIL//[^a-z@.]/}
#test -z $LIGHTLY_SANITIZED_EMAIL || python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); user = User.objects.get(
#email='$LIGHTLY_SANITIZED_EMAIL'); user.is_staff = True; user.is_admin = True; user.is_superuser = True; user.save();"

# Start celery in the background inside this container. This will spin down
# along with the dyno, but we should only have tasks while someone is
# actively interacting with the server anyways.
# If commented out, celery must be run offsite.
# celery -A cardboard worker -l INFO --without-heartbeat --without-gossip --without-mingle --concurrency 3 --beat &

exec gunicorn cardboard.wsgi -b 0.0.0.0:8000 --log-file -
