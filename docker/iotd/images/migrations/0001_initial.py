# Generated by Django 3.2.5 on 2021-07-15 07:11

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='FeaturedImage',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200)),
                ('tagline', models.TextField()),
                ('uploaded', models.DateTimeField(auto_now=True)),
                ('img', models.ImageField(upload_to='')),
            ],
        ),
    ]