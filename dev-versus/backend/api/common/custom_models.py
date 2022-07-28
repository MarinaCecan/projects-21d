from django.db import models
from django.core.serializers.json import DjangoJSONEncoder
import json


class JSONField(models.TextField):
    """
    serializes to/deserializes from JSON.
    Django snippet #1478
    Example:
        class Page(models.Model):
            data = JSONField(blank=True, null=True)
        page = Page.objects.get(pk=5)
        page.data = {'title': 'test', 'type': 3}
        page.save()
    """
    def to_python(self, value):
        if value == "":
            return None

        try:
            if isinstance(value, str):
                return json.loads(value)
        except ValueError:
            pass
        return value

    def from_db_value(self, value, *args):
        return self.to_python(value)

    def get_db_prep_save(self, value, *args, **kwargs):
        if value == "":
            return None
        if isinstance(value, dict):
            value = json.dumps(value, cls=DjangoJSONEncoder)
        return value
