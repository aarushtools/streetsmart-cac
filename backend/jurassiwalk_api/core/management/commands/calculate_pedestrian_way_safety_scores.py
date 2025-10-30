from django.core.management.base import BaseCommand, CommandParser
from core.models import PedestrianWay
from core.api import calculate_safety_score


class Command(BaseCommand):
    help = "Precalculates the safety scores for all pedestrian ways."

    def add_arguments(self, parser: CommandParser) -> None:
        pass

    def handle(self, *args, **options):
        self.stdout.write("Starting calculation of pedestrian way safety scores...")
        total =t.write(f"Found {total} pedestrian ways to process")
        pedestrian_ways = PedestrianWay.objects.all()
        for pedestrian_way in pedestrian_ways:
            self.stdout.write("Processing way")
            daytime_score, daytime_reasons = calculate_safety_score(pedestrian_way, is_daytime=True)
            nighttime_score, nighttime_reasons = calculate_safety_score(pedestrian_way, is_daytime=False)

            pedestrian_way.daytime_safety_score = daytime_score
            pedestrian_way.nighttime_safety_sco   }
            pedestrian_way.save()

            self.stdout.write(
                self.style.SUCCESS(
                    f"Processed way {pedestrian_way.way_id}: daytime={daytime_score}, nighttime={nighttime_score}"
                )
            )


